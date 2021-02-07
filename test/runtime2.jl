using DimReduc
using LazySets
import DimReduc: forward_network, forward_affine_map, ishull

nnet = read_nnet("nnet/84442.nnet")

delta = 0.4

solver1 = MaxSens(delta)
solver2 = FastGrid(delta)
solver3 = SpeGuid(delta)
solver4 = FastTree(delta)

in_hyper = Hyperrectangle(fill(1.0, 8), fill(1.0, 8))
out_hyper = Hyperrectangle(fill(0.0, 2), fill(10.0, 2))
problem = Problem(nnet, in_hyper, out_hyper)

file = open("results/group2.txt", "a")
print(file, "Test Result of Group 2: delta = $(delta)\n\n")

#solver1

time1 = 0

#solve(solver1, problem)
for i = 1:1
    timed_result =@timed solve(solver1, problem)
    print(file, "MaxSens - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time1 += timed_result.time
end

print(file, "Average time: " * string(time1/1) * " s\n\n")


#solver2

time2 = 0

#solve(solver2, problem)
for i = 1:1
    timed_result =@timed solve(solver2, problem)
    print(file, "FastGrid - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time2 += timed_result.time
end

print(file, "Average time: " * string(time2/1) * " s\n\n")


#solver3

time3 = 0

solve(solver3, problem)
for i = 1:10
    timed_result =@timed solve(solver3, problem)
    print(file, "SpeGuid - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time3 += timed_result.time
end

print(file, "Average time: " * string(time3/10) * " s\n\n")


#solver4

time4 = 0

solve(solver4, problem)
for i = 1:10
    timed_result =@timed solve(solver4, problem)
    print(file, "FastTree - test " * string(i) * " - Time: " * string(timed_result.time) * " s")
    print(file, " - Output: " * string(timed_result.value) * "\n")
    global time4 += timed_result.time
end

print(file, "Average time: " * string(time4/10) * " s\n\n")

close(file)
