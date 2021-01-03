# Libraries
library(shiny)
library(tidyverse)
library(cowplot)

# Load Data
app_data <- readRDS("data.Rds")

cell_type_colors <- app_data$colors
df_counts <- app_data$counts

valid_genes <- df_counts$gene_symbol %>% unique %>% sort

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Blood Cell RNA Expression"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectizeInput('gene', label="Gene", selected="Nudt21",
                        choices=valid_genes, multiple=TRUE),
            
            checkboxInput("log", "log scale", value=FALSE),
            
            div(
                strong("About"),
                p("Data is sourced from ", strong("Table S2"), " of ", 
                  a("Lara-Astiaso et al, Science, 2014.", href="https://science.sciencemag.org/content/345/6199/943"))
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("expression_plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$expression_plot <- renderPlot({
        if (input$log) {
            y_label <- "Counts Per 10M (log10[1+n])"
            y_trans <- "log10"
        } else {
            y_label <- "Counts Per 10M"
            y_trans <- "identity"
        }
        df_counts %>%
            filter(gene_symbol %in% input$gene) %>%
            mutate(gene_symbol=factor(gene_symbol, levels=input$gene)) %>%
            ggplot(aes(x=cell_type, y=CP10M + as.integer(input$log), fill=cell_type)) +
            geom_bar(stat='identity', color="black", size=0.3) +
            facet_grid(rows=vars(gene_symbol), scales='free_y') +
            scale_fill_manual(values=cell_type_colors) +
            scale_y_continuous(trans=y_trans) +
            labs(x="Cell Types", y=y_label) +
            guides(fill=FALSE, x=guide_axis(angle=90)) +
            theme_minimal_hgrid()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
