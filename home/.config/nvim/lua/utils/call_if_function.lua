return function(value, ...)
    if type(value) == "function" then
        return value(...)
    else
        return value
    end

end
