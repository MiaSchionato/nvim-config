local M = {}

local keywords = {
  date = os.date("%Y-%m-%d"),
  month =  os.date("%Y-%m"),
  today =  os.date("+%A"),
  -- hoje = vim.cmd("LC_TIME = pt_BR.UTF-8 date +%A"), --  and os.date("%A") or os.date("%A")
  tomorrow =  os.date("%Y-%m-%d", os.time() + 86400),
  yesterday = os.date("%Y-%m-%d", os.time() - 86400),
  time = os.date("%H:%M"),
  title = function()
    local filename = vim.fn.expand("%:t:r")
    if filename ~= "" then return filename or "Untitled" end
  end,
  id = os.date("%Y%m%d%H%M"),
}

local function processTemplate(contentStr)
  local finalContent = contentStr
    for key, value in pairs(keywords) do
      local placeholder = "{{" .. key .. "}}"
      if finalContent:find(placeholder, 1, true) then
        finalContent = finalContent:gsub(placeholder, value)
      end
    end

    return vim.split(finalContent, "\n")
end

local templatesDir = vim.fn.expand('~/Documents/MindGarden/8-templates/')
function M.insertTemplate()
    if vim.fn.isdirectory(templatesDir) == 0 then
        print("Erro: Pasta de templates não encontrada em " .. templatesDir)
        return
    end

  local files = vim.fn.readdir(templatesDir)
  vim.ui.select(files, { prompt = "Select your zettelKasten template"}, function(selected)
    if not selected then return end
    local filepath = templatesDir .. selected

    local file = io.open(filepath, "r")
    if not file then return end
    local content = file:read("*a")
    file:close()


    local linesToInsert = processTemplate(content)
    local cursorPos = vim.api.nvim_win_get_cursor(0)
    local row = cursorPos[1]

    vim.api.nvim_buf_set_lines(0, row -1, row -1, false,linesToInsert)
  end)
end

return M
