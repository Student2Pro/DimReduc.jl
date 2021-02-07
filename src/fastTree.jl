@with_kw struct FastTree
    tolerance::Float64 = 1.0
end

# This is the main function

function solve(solver::FastTree, problem::Problem)
    center = problem.input.center
    radius = problem.input.radius[1]
    (W, b) = (problem.network.layers[1].weights, problem.network.layers[1].bias)

    input = forward_affine_map(solver, W, b, problem.input)
    lower, upper = low(input), high(input)
    local_lower, local_upper = similar(lower), similar(lower)

    k_1 = size(W, 1)

    C = vcat(W, -W)
    d = zeros(2k_1)

    stack = Vector{Hyperrectangle}(undef, 0)
    push!(stack, input)
    #count = 0
    while !isempty(stack)
        interval = popfirst!(stack)
        reach = forward_network(solver, problem.network, interval)
        #count += 1
        if issubset(reach, problem.output)
            continue
        else
            if get_largest_width(interval) > solver.tolerance
                sections = bisect(interval)
                for i in 1:2
                    local_lower = low(sections[i])
                    local_upper = high(sections[i])
                    d = vcat(local_upper - b, b - local_lower)

                    inter = intersection(problem.input, HPolyhedron(C, d))

                    if isempty(inter) == false
                        push!(stack, sections[i])
                    end
                end
            else
                return BasicResult(:violated)
            end
        end
    end
    #println("DimTree($(solver.tolerance)): $(count)")
    return BasicResult(:holds)
end

function forward_network(solver::FastTree, nnet::Network, input::Hyperrectangle)
    layers = nnet.layers
    act = layers[1].activation
    reach = Hyperrectangle(low = act.(low(input)), high = act.(high(input)))

    for i in 2:length(layers)
        reach = forward_layer(solver, layers[i], reach)
    end
    return reach
end

function forward_layer(solver::FastTree, L::Layer, input::Hyperrectangle)
    (W, b, act) = (L.weights, L.bias, L.activation)
    center = zeros(size(W, 1))
    gamma  = zeros(size(W, 1))
    for j in 1:size(W, 1)
        node = Node(W[j,:], b[j], act)
        center[j], gamma[j] = forward_node(solver, node, input)
    end
    return Hyperrectangle(center, gamma)
end

function forward_node(solver::FastTree, node::Node, input::Hyperrectangle)
    output    = node.w' * input.center + node.b
    deviation = sum(abs.(node.w) .* input.radius)
    βmax = node.act(output + deviation)
    βmin = node.act(output - deviation)
    return ((βmax + βmin)/2, (βmax - βmin)/2)
end

function forward_affine_map(solver::FastTree, W::Matrix, b::Vector, input::Hyperrectangle)
    center = W * input.center + b
    radius = abs.(W) * input.radius
    return Hyperrectangle(center, radius)
end
