# Load R functions
for (script in list.files(here::here("R"), full.names = TRUE)) {
  source(script)
}

library(targets)
library(tarchetypes)
library(xaringanthemer)

rlang::list2(
  tar_file(
    theme,
    theme_file(
      style_mono_accent(
        base_color = "#1f0536",
        header_font_google = google_font("Cookie"),
        text_font_google   = google_font("Montserrat", "300 ", "300i"),
        code_font_google   = google_font("Fira Mono")
      ),
      style_extra_css(
        css = list(
          ":root" = list(
            "--header-h1-font-size" = "3rem",
            "--header-h2-font-size" = "2rem"
          ),
          "h2, h3" = list(
            "font-family" = "var(--text-font-family)"
          ),
          ".ties-footer" = list(
            position = "fixed",
            bottom = 0,
            "text-align" = "left"
          ),
          ".ties-footer p img" = list(
            width = "30%"
          )
        )
      )
    )
  ),

  tar_files_copy(
    move_theme,
    theme,
    here::here("www/xaringan-themer.css")
  ),

  tar_file(
    site_config,
    here::here("www/_site.yml")
  ),

  tar_target(
    site_deps,
    rlang::list2(
      move_theme,
      site_config,
    )
  ),

  tar_target(
    build_site,
    {
      site_deps
      rmarkdown::render_site(
        input = here::here("www"),
        quiet = TRUE
      )
    },
    cue = tar_cue_force(TRUE)
  ),
)