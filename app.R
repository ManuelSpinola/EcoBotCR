# ============================================================
# app.R
# EcoBotCR — Asistente virtual sobre Biodiversidad de Costa Rica
# Powered by Google Gemini 2.5 Flash · OVS-CR · ICOMVIS · UNA
# ============================================================

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

ui <- fluidPage(

  theme = bs_theme(
    version   = 5,
    bg        = "#ffffff",
    fg        = "#1a1a1a",
    primary   = "#a31e32",
    base_font = font_google("Nunito")
  ),

  tags$style(HTML("
    body { margin: 0; padding: 0; }

    .banner-titulo {
      background-color: #a31e32;
      color: white;
      font-weight: bold;
      text-align: center;
      padding: 18px 30px;
      font-size: 1.6rem;
      margin-bottom: 0;
    }

    .panel-sidebar-custom {
      background-color: #F8F0F0 !important;
      color: #a31e32 !important;
      padding: 18px;
      height: 100%;
      min-height: 500px;
      border-right: 1px solid #E8C8C8;
    }

    .panel-sidebar-custom h5 {
      font-weight: bold;
      color: #a31e32;
      margin-top: 15px;
      margin-bottom: 10px;
    }

    .panel-sidebar-custom ul {
      padding-left: 16px;
      margin: 0;
      color: #2C2C2C;
    }

    .panel-sidebar-custom li {
      margin-bottom: 8px;
      font-size: 14px;
      color: #2C2C2C;
    }

    .logo-caption {
      font-style: italic;
      font-size: 11px;
      color: #a31e32;
      text-align: center;
      margin-top: 6px;
    }

    .panel-chat {
      background-color: #fdf6f6;
      padding: 10px;
      height: 100%;
    }

    @media (max-width: 768px) {
      .banner-titulo { font-size: 1.1rem; padding: 12px 15px; }
      .col-sm-3 { width: 100% !important; }
      .col-sm-9 { width: 100% !important; }
      .panel-sidebar-custom { min-height: unset; }
    }
  ")),

  div(class = "banner-titulo",
    "CR BioBot: tu asistente virtual sobre la Biodiversidad de Costa Rica"
  ),

  fluidRow(
    style = "padding: 0; margin: 0;",

    column(3,
      style = "padding: 0;",
      div(class = "panel-sidebar-custom",
        div(
          style = "text-align: center; margin-bottom: 5px;",
          tags$img(
            src   = "logo_2.png",
            width = "55%",
            style = "border-radius: 50%;"
          ),
          div(class = "logo-caption",
            tags$span(style = "font-size: 13px; color: #a31e32; font-style: italic;",
              "Con la ayuda de Talentoso, el oso perezoso sabio"),
            tags$br(),
            tags$span(style = "font-size: 10px;",
              "Ilustración por Gemini 2.0 Flash y Maritza Ramírez")
          )
        ),
        hr(style = "border-color: #c0394a; margin: 10px 0;"),
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
      style = "padding: 0;",
      div(class = "panel-chat",
        chat_ui("chat",
                placeholder = "Escribe tu pregunta aquí...",
                height      = "calc(100vh - 120px)")
      )
    )
  ),

  div(
    style = paste0(
      "background-color:#a31e32; color:#ffffff; ",
      "text-align:center; padding:6px 12px; ",
      "font-size:0.75rem; line-height:1.6;"
    ),
    "Manuel Spínola · ICOMVIS · Universidad Nacional · Costa Rica"
  )
)

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
