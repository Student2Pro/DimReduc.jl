using JLD2, Printf

@load "MNIST_1000.jld2" train_x train_y

file = open("data.txt", "a")

print(file, "data = [")

for i in 0:9
    count = 0
    for j in 1:1000
        if train_y[j] == i
            data = reshape(train_x[:,:,j], 784)
            print(file, "[")
            for k in 1:784
                @printf(file, "%f, ", data[k])
            end
            print(file, "],\n")
            count += 1
        end
        if count == 10
            break
        end
    end
end

print(file, "]")

close(file)
