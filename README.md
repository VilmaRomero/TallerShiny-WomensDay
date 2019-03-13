# Women's Day: Por m�s mujeres en tecnolog�a
***
# *Crea tu primera app en 45 minutos con Shiny y R*
***
## Descripci�n
Este taller tiene como objetivo introducir a los participantes el uso del paquete **`shiny`**. Este paquete permite construir de manera sencilla aplicaciones web interactivas directamente desde R. Adem�s, gracias a que la elaboraci�n se realiza completamente desde R, se tiene la ventaja de que los usuarios no s�lo puedan interactuar con los datos sino tambi�n con sus respectivos an�lisis.

Al finalizar de este taller, habremos construido lo siguiente:

![](FinalApp.png)

El despliegue de esta aplicaci�n se encuentra en <https://vilsurr.shinyapps.io/tallershinywomensday/>

## Datos
Los datos que se usan para crear esta aplicaci�n est�n contenidos en la carpeta **"world-happiness-report"** y han sido tomados de la plataforma  [Kaggle](https://www.kaggle.com). La informaci�n mostrada est� basada en una encuesta hist�rica del estado de la felicidad global. Si deseas conocer a mayor detalle estos datos, puedes revisar este [enlace](https://www.kaggle.com/unsdsn/world-happiness).

## Paquetes a utilizar
Para que la aplicaci�n puede ejecutarse adecuadamente se necesita tener instalados los siguientes paquetes:

```r
install.packages("shiny")
install.packages("leaflet")
install.packages("rgdal")
install.packages("tidyverse")
install.packages("plotly")
install.packages("DT")
install.packages("htmltools")
```

## Algunas consideraciones
- El archivo principal de construcci�n es el script **app.R**. 
- Se debe descargar completamente este repositorio y establecerlo como directorio de trabajo antes de ejecutar el script **app.R**. Caso contrario, algunos resultados de la aplicaci�n generar�n error.
- La aplicaci�n ser� creada en el servidor local por defecto. Si deseas que se encuentre en la web, puedes realizar el despliegue haciendo uso de [Shinyapp.io](https://www.shinyapps.io).

## Recursos adicionales

- [**Hoja de referencia de Shiny**](https://www.rstudio.com/resources/cheatsheets/)
- P�gina oficial de Shiny - [**http://shiny.rstudio.com**](http://shiny.rstudio.com)
- Tutorial oficial de Shiny - [**http://shiny.rstudio.com/tutorial/**](http://shiny.rstudio.com/tutorial/)

