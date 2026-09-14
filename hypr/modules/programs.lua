HyprXPrograms = {
    app = function(command)
        return hl.dsp.exec_cmd("uwsm app -- " .. command)
    end,
    exec = hl.dsp.exec_cmd,
}
