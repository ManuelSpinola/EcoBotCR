# ============================================================
# app.R
# EcoBotCR — Asistente virtual sobre Biodiversidad de Costa Rica
# Powered by Google Gemini · OVS-CR · ICOMVIS · UNA
# ============================================================

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

# ── UI ───────────────────────────────────────────────────────
ui <- fluidPage(

  # Tema
  theme = bs_theme(
    version   = 5,
    bg        = "#ffffff",
    fg        = "#1a1a1a",
    primary   = "#a31e32",
    base_font = font_google("Nunito")
  ),

  # Banner rojo título
  div(
    style = "background-color: #a31e32; color: white; padding: 20px; text-align: center; margin-bottom: 20px;",
    h2(style = "font-weight: bold; margin: 0;",
       "CR BioBot: tu asistente virtual sobre la Biodiversidad de Costa Rica")
  ),

  # Título secundario
  div(
    style = "padding: 0 20px;",
    h3("Con la ayuda de Talentoso, el oso perezoso sabio")
  ),

  # Logo centrado
  div(
    class = "text-center my-3",
    tags$img(src = "logo_2.png", width = "35%"),
    tags$p(
      tags$em("Ilustración por Gemini 2.0 Flash y Maritza Ramírez"),
      style = "color: #666; font-size: 14px; margin-top: 8px;"
    )
  ),

  # Layout sidebar + chat
  div(
    style = "padding: 0 20px;",
    fluidRow(
      # Sidebar roja
      column(3,
        div(
          style = "background-color: #a31e32; color: white; padding: 20px; border-radius: 8px;",
          h5(style = "font-weight: bold;", "Ejemplos de preguntas"),
          tags$ul(
            style = "padding-left: 15px; margin: 0;",
            tags$li("¿Cuáles parques nacionales hay en Guanacaste?"),
            tags$li("¿Qué especies de aves son comunes en Monteverde?"),
            tags$li("¿Por qué Costa Rica es un hotspot de biodiversidad?"),
            tags$li("Nómbrame cinco especies endémicas de Costa Rica")
          )
        )
      ),
      # Chat
      column(9,
        chat_ui("chat",
                placeholder = "Escribe tu pregunta aquí...",
                height      = "400px")
      )
    )
  ),

  # Footer
  div(
    style = "text-align: center; font-size: 13px; color: #555; margin-top: 40px; padding: 20px;",
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
      '<span style="font-size: 16px;">🦥 Hola, soy Talentoso, un oso perezoso dispuesto a responder tus preguntas sobre la biodiversidad de Costa Rica. ¡Tranqui! te ayudo con calma.</span>'
    )
  })

  observeEvent(input$chat_user_input, {
    req(input$chat_user_input)
    response <- chat$chat(input$chat_user_input)
    chat_append("chat", response)
  })
}

shinyApp(ui, server)
