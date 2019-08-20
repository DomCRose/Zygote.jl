using Zygote, Test

function tasks1(x)
  ch = Channel(Inf)
  put!(ch, x^2) + take!(ch)
end

@test gradient(tasks1, 5) == (20,)

function tasks2(x)
  ch = Channel(0)
  t = @async put!(ch, x^2)
  y = take!(ch)
  wait(t)
  return y
end

@test gradient(tasks2, 5) == (10,)

function tasks3(x)
  ch = Channel(0)
  @sync begin
    @async put!(ch, x^2)
    take!(ch)
  end
end

@test gradient(tasks3, 5) == (10,)

function tasks4(x)
  ch = Channel(Inf)
  @sync begin
    t = @spawn put!(ch, x^2)
    take!(ch)
  end
end

@test gradient(tasks4, 5) == (10,)
