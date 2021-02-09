using DimReduc
using LazySets
import DimReduc: forward_network, forward_affine_map

nnet1 = read_nnet("nnet/mnist_1000.nnet")
nnet2 = read_nnet("nnet/mnist_large.nnet")
nnet3 = read_nnet("nnet/mnist3.nnet")
nnet4 = read_nnet("nnet/mnist4.nnet")

solver = FastGrid(1)

center = zeros(784)
radius = 0.004
inputSet = Hyperrectangle(low=center .- radius, high=center .+ radius)

file = open("results/affinemap.txt", "a")

print(file, "mnist1\n")
W, b = nnet1.layers[1].weights, nnet1.layers[1].bias
Q = forward_affine_map(solver, W, b, inputSet)
print(file, "width = $(sort(Q.radius) .* 2)\n")

print(file, "mnist2\n")
W, b = nnet2.layers[1].weights, nnet2.layers[1].bias
Q = forward_affine_map(solver, W, b, inputSet)
print(file, "width = $(sort(Q.radius) .* 2)\n")

print(file, "mnist3\n")
W, b = nnet3.layers[1].weights, nnet3.layers[1].bias
Q = forward_affine_map(solver, W, b, inputSet)
print(file, "width = $(sort(Q.radius) .* 2)\n")

print(file, "mnist4\n")
W, b = nnet4.layers[1].weights, nnet4.layers[1].bias
Q = forward_affine_map(solver, W, b, inputSet)
print(file, "width = $(sort(Q.radius) .* 2)\n")

close(file)
