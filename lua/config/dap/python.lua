local M = {}

function M.setup() 
  require('dap-python').setup('/usr/local/bin/python') 
end

return M

