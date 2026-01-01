local function ensure_html_deps()
  quarto.doc.add_html_dependency({
    name = "pseudocode",
    version = "2.4.1",
    scripts = { "pseudocode.min.js" },
    stylesheets = { "pseudocode.min.css" }
  })
  quarto.doc.include_text("in-header", [[
    <style type="text/css">
    .ps-root .ps-algorithm {
      border-top: 2px solid;
      border-bottom: 2px solid;
    }
    .pseudocode-container {
      text-align: left;
    }
    </style>
  ]])
  quarto.doc.include_text("after-body", [[
    <script type="text/javascript">
    (function(d) {
      d.querySelectorAll(".pseudocode-container").forEach(function(el) {
        let pseudocodeOptions = {
          indentSize: el.dataset.indentSize,
          commentDelimiter: el.dataset.commentDelimiter,
          lineNumber: el.dataset.lineNumber.toLowerCase() === "true",
          lineNumberPunc: el.dataset.lineNumberPunc,
          noEnd: el.dataset.noEnd.toLowerCase() === "true",
          titlePrefix: el.dataset.captionPrefix
        };
        pseudocode.renderElement(el.querySelector(".pseudocode"), pseudocodeOptions);
      });
    })(document);
    (function(d) {
      d.querySelectorAll(".pseudocode-container").forEach(function(el) {
        let captionSpan = el.querySelector(".ps-root > .ps-algorithm > .ps-line > .ps-keyword")
        if (captionSpan !== null) {
          let captionPrefix = el.dataset.captionPrefix + " ";
          let captionNumber = "";
          if (el.dataset.pseudocodeNumber) {
            captionNumber = el.dataset.pseudocodeNumber + " ";
            if (el.dataset.chapterLevel) {
              captionNumber = el.dataset.chapterLevel + "." + captionNumber;
            }
          }
          captionSpan.innerHTML = captionPrefix + captionNumber;
        }
      });
    })(document);
    </script>
  ]])
end

local function nil_to_default(value, default)
  if value == nil then
    return default
  else
    return value
  end
end

local function ensure_latex_deps()
  quarto.doc.use_latex_package("algorithm")
  quarto.doc.use_latex_package("algpseudocode")
  quarto.doc.use_latex_package("caption")
  quarto.doc.include_text("in-header", [[
    \makeatletter
    \newcommand\fs@nocaption{
      \def\@fs@cfont{\bfseries}
      \let\@fs@capt\floatc@plain
      \def\@fs@pre{}%
      \def\@fs@post{\kern2pt\hrule}%
      \def\@fs@mid{\hrule\kern2pt}%
      \let\@fs@iftopcapt\iftrue}
    \makeatother
  ]])
end

local function extract_source_code_options(source_code, render_type)
  local options = {}
  local source_codes = {}
  local found_source_code = false

  for str in string.gmatch(source_code, "([^\n]*)\n?") do
    if (string.match(str, "^%s*#|.*") or string.gsub(str, "%s", "") == "") and not found_source_code then
      if string.match(str, "^%s*#|%s+[" .. render_type .. "|label].*") then
        str = string.gsub(str, "^%s*#|%s+", "")
        local idx_start, idx_end = string.find(str, ":%s*")

        if idx_start and idx_end and idx_end + 1 < #str then
          k = string.sub(str, 1, idx_start - 1)
          v = string.sub(str, idx_end + 1)
          v = string.gsub(v, "^\"%s*", "")
          v = string.gsub(v, "%s*\"$", "")

          options[k] = v
        else
          quarto.log.warning("Invalid pseducode option: " .. str)
        end
      end
    else
      found_source_code = true
      table.insert(source_codes, str)
    end
  end

  return options, table.concat(source_codes, "\n")
end

local function render_pseudocode_block_html(global_options)
  ensure_html_deps()

  if global_options.caption_align then
    quarto.doc.include_text("in-header", [[
      <style type="text/css">
      .ps-algorithm > .ps-line {
        text-align: ]] .. global_options.caption_align .. [[;
      }
      </style>
    ]])
  end

  local filter = {
    CodeBlock = function(el)
      if not el.attr.classes:includes("pseudocode") then
        return el
      end

      local options, source_code = extract_source_code_options(el.text, "html")

      source_code = string.gsub(source_code, "%s*\\begin{algorithm}[^\n]+", "\\begin{algorithm}")
      source_code = string.gsub(source_code, "%s*\\begin{algorithmic}[^\n]+", "\\begin{algorithmic}")

      local algorithm_id = options["label"]
      options["label"] = nil
      options["html-caption-prefix"] = global_options.caption_prefix

      if global_options.number_with_in_chapter and global_options.html_chapter_level then
        options["html-chapter-level"] = global_options.html_chapter_level
      end

      if global_options.caption_number then
        options["html-pseudocode-number"] = global_options.html_current_number
      end

      options["html-indent-size"] = nil_to_default(options["html-indent-size"], "1.2em")
      options["html-comment-delimiter"] = nil_to_default(options["html-comment-delimiter"], "//")
      options["html-line-number"] = string.lower(nil_to_default(options["html-line-number"], "true"))
      options["html-line-number-punc"] = nil_to_default(options["html-line-number-punc"], ":")
      options["html-no-end"] = string.lower(nil_to_default(options["html-no-end"], "false"))

      local data_options = {}
      for k, v in pairs(options) do
        if string.match(k, "^html-") then
          data_k = string.gsub(k, "^html", "data")
          data_options[data_k] = v
        end
      end

      local inner_el = pandoc.Div(source_code)
      inner_el.attr.classes = pandoc.List()
      inner_el.attr.classes:insert("pseudocode")

      local outer_el = pandoc.Div(inner_el)
      outer_el.attr.classes = pandoc.List()
      outer_el.attr.classes:insert("pseudocode-container")
      outer_el.attr.classes:insert("quarto-float")
      outer_el.attr.attributes = data_options

      if algorithm_id then
        outer_el.attr.identifier = algorithm_id
        global_options.html_identifier_number_mapping[algorithm_id] = global_options.html_current_number
        global_options.html_current_number = global_options.html_current_number + 1
      end

      return outer_el
    end
  }

  return filter
end

local function render_pseudocode_block_latex(global_options)
  ensure_latex_deps()

  if global_options.caption_number then
    quarto.doc.include_text("before-body", "\\floatname{algorithm}{" .. global_options.caption_prefix .. "}")
  else
    quarto.doc.include_text("in-header", "\\DeclareCaptionLabelFormat{algnonumber}{" .. global_options.caption_prefix .. "}")
    quarto.doc.include_text("before-body", "\\captionsetup[algorithm]{labelformat=algnonumber}")
  end

  if global_options.caption_align then
    if global_options.caption_align == "center" then
      quarto.doc.include_text("in-header", "\\captionsetup[algorithm]{justification=centering}")
    elseif global_options.caption_align == "right" then
      quarto.doc.include_text("in-header", "\\captionsetup[algorithm]{justification=raggedleft}")
    else
      quarto.doc.include_text("in-header", "\\captionsetup[algorithm]{justification=raggedright}")
    end
  end

  if global_options.number_with_in_chapter then
    quarto.doc.include_text("before-body", "\\numberwithin{algorithm}{chapter}")
  end

  local filter = {
    CodeBlock = function(el)
      if not el.attr.classes:includes("pseudocode") then
        return el
      end

      local options, source_code = extract_source_code_options(el.text, "pdf")

      options["pdf-placement"] = nil_to_default(options["pdf-placement"], "H")
      source_code = string.gsub(source_code, "\\begin{algorithm}%s*\n",
        "\\begin{algorithm}[" .. options["pdf-placement"] .. "]\n")

      if string.lower(nil_to_default(options["pdf-line-number"], "true")) == "true" then
        source_code = string.gsub(source_code, "\\begin{algorithmic}%s*\n", "\\begin{algorithmic}[1]\n")
      else
        source_code = string.gsub(source_code, "\\begin{algorithmic}%s*\n", "\\begin{algorithmic}[0]\n")
      end

      if options["label"] then
        source_code = string.gsub(source_code, "\\caption{", "\\caption{\\label{" .. options["label"] .. "}")
      end

      if string.find(source_code, "\\caption{") then
        source_code = "\\floatstyle{ruled}\n\\restylefloat{algorithm}\n" .. source_code .. "\n\\floatstyle{plain}\n"
      else
        source_code = "\\floatstyle{nocaption}\n\\restylefloat{algorithm}\n" .. source_code .. "\n\\floatstyle{plain}\n"
      end

      return pandoc.RawInline("latex", source_code)
    end
  }

  return filter
end

local function render_pseudocode_block(global_options)
  local filter = {
    CodeBlock = function(el)
      return el
    end
  }

  if quarto.doc.is_format("html") then
    filter = render_pseudocode_block_html(global_options)
  elseif quarto.doc.is_format("latex") then
    filter = render_pseudocode_block_latex(global_options)
  end

  return filter
end

local function render_pseudocode_ref_html(global_options)
  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)

      for k, v in pairs(global_options.html_identifier_number_mapping) do
        if cite_text == "@" .. k then
          local link_src = "#" .. k
          local algorithm_id = v

          if global_options.html_chapter_level then
            algorithm_id = global_options.html_chapter_level .. "." .. algorithm_id
          end

          local link_text = global_options.reference_prefix .. " " .. algorithm_id
          local link = pandoc.Link(link_text, link_src)
          link.attr.classes = pandoc.List()
          link.attr.classes:insert("quarto-xref")

          return link
        end
      end
    end
  }

  return filter
end

local function render_pseudocode_ref_latex(global_options)
  local filter = {
    Cite = function(el)
      local cite_text = pandoc.utils.stringify(el.content)

      if string.match(cite_text, "^@algo-") then
        return pandoc.RawInline("latex",
          global_options.reference_prefix .. "~\\ref{" .. string.gsub(cite_text, "^@", "") .. "}")
      end
    end
  }

  return filter
end

local function render_pseudocode_ref(global_options)
  local filter = {
    Cite = function(el)
      return el
    end
  }

  if quarto.doc.is_format("html") then
    filter = render_pseudocode_ref_html(global_options)
  elseif quarto.doc.is_format("latex") then
    filter = render_pseudocode_ref_latex(global_options)
  end

  return filter
end

function Pandoc(doc)
  local global_options = {
    caption_prefix = "Algorithm",
    reference_prefix = "Algorithm",
    caption_number = true,
    caption_align = "left",
    number_with_in_chapter = false,
    html_chapter_level = nil,
    html_current_number = 1,
    html_identifier_number_mapping = {}
  }

  if doc.meta["pseudocode"] then
    global_options.caption_prefix = pandoc.utils.stringify(nil_to_default(doc.meta["pseudocode"]["caption-prefix"],
      global_options.caption_prefix))
    global_options.reference_prefix = pandoc.utils.stringify(nil_to_default(doc.meta["pseudocode"]["reference-prefix"],
      global_options.reference_prefix))
    global_options.caption_number = nil_to_default(doc.meta["pseudocode"]["caption-number"],
      global_options.caption_number)
    global_options.caption_align = pandoc.utils.stringify(nil_to_default(doc.meta["pseudocode"]["caption-align"],
      global_options.caption_align))
  end

  if doc.meta["book"] then
    global_options.number_with_in_chapter = true

    if quarto.doc.is_format("html") then
      local _, input_qmd_filename = string.match(quarto.doc["input_file"], "^(.-)([^\\/]-%.([^\\/%.]-))$")
      local renders = doc.meta["book"]["render"]

      for _, render in pairs(renders) do
        if render["file"] and render["number"] and pandoc.utils.stringify(render["file"]) == input_qmd_filename then
          global_options.html_chapter_level = pandoc.utils.stringify(render["number"])
        end
      end
    end
  end

  doc = doc:walk(render_pseudocode_block(global_options))

  return doc:walk(render_pseudocode_ref(global_options))
end
