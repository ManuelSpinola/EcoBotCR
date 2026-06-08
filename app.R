# ============================================================
# app.R
# EcoBotCR — Asistente virtual sobre Biodiversidad de Costa Rica
# Powered by Google Gemini 2.5 Flash · OVS-CR · ICOMVIS · UNA
# ============================================================

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

# ── UI ───────────────────────────────────────────────────────
ui <- fluidPage(

  theme = bs_theme(
    version   = 5,
    bg        = "#ffffff",
    fg        = "#1a1a1a",
    primary   = "#a31e32",
    base_font = font_google("Nunito")
  ),

  # CSS adicional para replicar el estilo original
  tags$style(HTML("
    body { margin: 0; padding: 0; }

    .banner-titulo {
      background-color: #a31e32;
      color: white;
      font-weight: bold;
      text-align: center;
      padding: 18px 30px;
      font-size: 1.6rem;
      margin-bottom: 20px;
    }

    .subtitulo {
      font-size: 1.4rem;
      font-weight: bold;
      padding: 0 30px 10px 30px;
    }

    .logo-container {
      text-align: center;
      padding: 10px 0 5px 0;
    }

    .logo-caption {
      text-align: center;
      font-style: italic;
      color: #666;
      font-size: 13px;
      margin-bottom: 15px;
    }

    .panel-sidebar-custom {
      background-color: #a31e32 !important;
      color: white !important;
      padding: 18px;
      border-radius: 6px;
    }

    .panel-sidebar-custom h5 {
      font-weight: bold;
      margin-bottom: 12px;
    }

    .panel-sidebar-custom ul {
      padding-left: 16px;
      margin: 0;
    }

    .panel-sidebar-custom li {
      margin-bottom: 8px;
      font-size: 14px;
    }

    .panel-chat {
      background-color: #fdf6f6;
      border-radius: 6px;
      padding: 10px;
    }

    .footer-text {
      text-align: center;
      font-size: 12px;
      color: #666;
      padding: 30px 40px 20px 40px;
    }

    /* Responsive móvil */
    @media (max-width: 768px) {
      .banner-titulo { font-size: 1.1rem; padding: 12px 15px; }
      .subtitulo { font-size: 1.1rem; padding: 0 15px 10px 15px; }
      .logo-container img { width: 65% !important; }
      .col-sm-3 { width: 100% !important; margin-bottom: 15px; }
      .col-sm-9 { width: 100% !important; }
      .footer-text { padding: 20px 15px; font-size: 11px; }
    }
  ")),

  # Banner título
  div(class = "banner-titulo",
    "CR BioBot: tu asistente virtual sobre la Biodiversidad de Costa Rica"
  ),

  # Subtítulo
  div(class = "subtitulo",
    "Con la ayuda de Talentoso, el oso perezoso sabio"
  ),

  # Logo centrado
  div(class = "logo-container",
    tags$img(src = "logo_2.png", width = "30%")
  ),
  div(class = "logo-caption",
    "Ilustración por Gemini 2.0 Flash y Maritza Ramírez"
  ),

  # Layout sidebar + chat
  fluidRow(
    style = "padding: 0 20px; margin: 0;",

    column(3,
      div(class = "panel-sidebar-custom",
        h5("Ejemplos de preguntas"),
        tags$ul(
          tags$li("¿Cuáles parques nacionales hay en Guanacaste?"),
          tags$li("¿Qué especies de aves son comunes en Monteverde?"),
          tags$li("¿Por qué Costa Rica es un hotspot de biodiversidad?"),
          tags$li("Nómbrame cinco especies endémicas de Costa Rica")
        )
      )
    ),

    column(9,
      div(class = "panel-chat",
        chat_ui("chat",
                placeholder = "Escribe tu pregunta aquí...",
                height      = "420px")
      )
    )
  ),

  # Footer
  div(class = "footer-text",
    p("© 2025 Observatorio de Vida Silvestre y Biodiversidad de Costa Rica, ICOMVIS-UNA. Este asistente utiliza Gemini 2.5 Flash (Google AI) como motor de lenguaje. Google no respalda ni administra esta aplicación."),
    p("Nota: Este asistente virtual no es un experto en biodiversidad, sino un modelo de lenguaje que intenta proporcionar información precisa y útil. Sin embargo, siempre es recomendable consultar fuentes adicionales para obtener información más detallada y actualizada.")
  )
)

# ── Server ───────────────────────────────────────────────────
server <- function(input, output, session) {

  chat <- ellmer::chat_google_gemini(
    model = "gemini-2.5-flash",
    system_prompt = "
Responde únicamente preguntas relacionadas con la biodiversidad de Costa Rica,
incluyendo especies, ecosistemas, áreas protegidas, conservación y amenazas.
Incluye siempre al menos una fuente confiable en la respuesta, como SINAC, GBIF,
o publicaciones científicas relevantes.
Si la pregunta no está relacionada con biodiversidad, responde que solo puedes
responder sobre ese tema."
  )

  observe({
    chat_append(
      "chat",
      paste0('<span style="font-size: 16px;">🦥 Hola, soy <strong>Talentoso</strong>, ',
             'un oso perezoso dispuesto a responder tus preguntas sobre la biodiversidad ',
             'de Costa Rica. ¡Tranqui! te ayudo con calma.</span>')
    )
  })

  observeEvent(input$chat_user_input, {
    req(input$chat_user_input)
    response <- chat$chat(input$chat_user_input)
    chat_append("chat", response)
  })
}

shinyApp(ui, server)
