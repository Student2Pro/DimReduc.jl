using DimReduc
using LazySets
import DimReduc: forward_network, forward_affine_map, ishull

nnet = read_nnet("nnet/84442.nnet")

delta = 0.1

solver1 = MaxSens(delta)
solver2 = FastGrid(delta)
solver3 = SpeGuid(delta)
solver4 = FastTree(delta)

in_hyper = Hyperrectangle(fill(0.5, 8), fill(0.5, 8))
out_hyper = Hyperrectangle(fill(0.0, 2), fill(0.2, 2))
problem = Problem(nnet, in_hyper, out_hyper)

reach = forward_network(solver3, problem.network, in_hyper)

file = open("results/group1.txt", "a")
print(file, "Test Result of Group 1: delta = $(delta)\n\n")

#solver1

#solver2


#solver3

time3 = 0

solve(solver3, problem)
for i = 1:2
    timed_result =@timed solve(solver3, problem)
    print(file, "SpeGuid - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time3 += timed_result.time
end

print(file, "Average time: " * string(time3/2) * " s\n\n")


#solver4

time4 = 0

solve(solver4, problem)
for i = 1:2
    timed_result =@timed solve(solver4, problem)
    print(file, "FastTree - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time4 += timed_result.time
end

print(file, "Average time: " * string(time4/2) * " s\n\n")

close(file)
