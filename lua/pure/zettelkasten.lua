local M = {}

local function processTemplate(contentStr)
    local dateToday = os.date("%Y-%m-%d")
    local timeNow = os.date("%H:%M")
    local zettelID = os.date("%Y%m%d%H%M")

    local filename = vim.fn.expand("%:t:r")
    if filename == "" then filename = "Untitled" end

    local finalContent = contentStr
    finalContent = finalContent:gsub("{{date}}", dateToday)
    finalContent = finalContent:gsub("{{time}}", timeNow)
    finalContent = finalContent:gsub("{{title}}", filename)
    finalContent = finalContent:gsub("{{id}}", zettelID)

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
    local row, _ = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, row -1, row -1, false,linesToInsert)
  end)
end

return M
