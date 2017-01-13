local tablex = require 'pl.tablex'
local utilities = require 'babi.utilities'

BABI_HOME = os.getenv('BABI_HOME') or utilities.babi_home()

local function generate(task_name, number, output, user_config)
    local task = require('babi.tasks.' .. task_name)
    local config = task.DEFAULT_CONFIG or {}
    config = tablex.merge(config, user_config, true)

    math.randomseed(os.time())
    for i = 1, number do
        local story
        repeat
            story = task:generate(config)
        until story
        output:write(story .. '\n')
    end
end


assert(#arg > 0, 'Usage: generate.lua task [number] [output_file] [--option value ...]')

local task_names = {
    [1]='WhereIsActor',
    [2]='WhereIsObject',
    [3]='WhereWasObject',
    [4]='IsDir',
    [5]='WhoWhatGave',
    [6]='IsActorThere',
    [7]='Counting',
    [8]='Listing',
    [9]='Negation',
    [10]='Indefinite',
    [11]='BasicCoreference',
    [12]='Conjunction',
    [13]='CompoundCoreference',
    [14]='Time',
    [15]='Deduction',
    [16]='Induction',
    [17]='PositionalReasoning',
    [18]='Size',
    [19]='PathFinding',
    [20]='Motivations'
}

local generate_arg = {
    tonumber(arg[1]) and assert(task_names[tonumber(arg[1])]) or arg[1],
    1,
    io.stdout,
    {}
}

for i = 2, #arg do
    if arg[i]:sub(1,2) == '--' then
        for j = i, #arg, 2 do
            local flag = arg[j]:sub(3, -1):gsub('-', '_')
            generate_arg[4][flag] = tonumber(arg[j + 1]) or arg[j + 1]
        end
        break
    elseif i == 2 then
        generate_arg[2] = assert(tonumber(arg[2]))
    elseif i == 3 then
        generate_arg[3] = assert(io.open(arg[3], 'a'))
    end
end
generate(unpack(generate_arg))
