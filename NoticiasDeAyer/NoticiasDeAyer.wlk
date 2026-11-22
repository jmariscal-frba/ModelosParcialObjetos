class Noticia{
    // ERROR 1 (grave): estos const no son "property", asi que desde afuera NO existen
    // noticia.titulo(), noticia.desarrollo() ni noticia.fechaPublicacion().
    // Las usan Sensacionalista, Vago, joseDeZar y Periodista.noPreferidasDeHoy -> todo eso falla al ejecutar.
    // COMO ARREGLARLO: const property fechaPublicacion / const property desarrollo / const property titulo
    const fechaPublicacion
//    const autor
    // ERROR 2 (grave): "1..10" es un RANGO, no un numero. Con eso, "gradoImportancia >= 8" no tiene sentido.
    // COMO ARREGLARLO: const gradoImportancia   (sin valor por defecto; el numero se pasa al crear la noticia)
    const gradoImportancia
    const property desarrollo
    const property titulo

    method esCopada() = self.esImportante() && self.esReciente() && self.criterioNoticia()
    method criterioNoticia()
    method esImportante() = gradoImportancia >= 8
    method esReciente() {
        const hoy = new Date()
        return fechaPublicacion <= hoy && (hoy - fechaPublicacion) < 3
    }
    // ERROR 3 (grave): la condicion de desarrollo esta invertida. "desarrollo.isEmpty()" es true cuando
    // NO tiene desarrollo, y el enunciado pide que SI tenga.
    // COMO ARREGLARLO: ... && !desarrollo.isEmpty()
    // (ademas, verifica que tu version de Wollok tenga String.words(); si no, usa split(" "))
    method estaBienEscrita() = titulo.words().size() >= 2 && !desarrollo.isEmpty()
    method esChivo() = false
    method aceptaEntrevistado(persona) = true // para cumplir con la condicion de Sensacionalista
}

class Comun inherits Noticia{
    const link = []

     method agregarLink(hipervinculo){ link.add(hipervinculo) }
     method tieneLink() = link.size() >= 2

     override method criterioNoticia() = self.tieneLink()
}

class Chivo inherits Noticia{
//    const producto
    const dineroPagado // En millones

    method pagoSuficiente() = dineroPagado > 2 // En millones

    override method criterioNoticia() = self.pagoSuficiente()
    override method esChivo() = true
}

class Reportaje inherits Noticia{
    const entrevistado

    override method criterioNoticia() = entrevistado.size().odd()
    override method aceptaEntrevistado(persona) = entrevistado == persona
}

class Cobertura inherits Noticia{
    const noticias = #{}

    method agregarNoticia(noticia) {noticias.add(noticia)}
    method noticiasCopadas() = noticias.forAll({noticia => noticia.esCopada()})

    override method criterioNoticia() = self.noticiasCopadas()

}

class Periodista{
//    const nombre
    const fechaIngreso
    const preferencia
    const noticiasPublicadas = []
    // ERROR 4 (medio): "hoy" se calcula UNA vez, cuando se crea el periodista, y queda congelado.
    // Si el objeto vive de un dia para el otro, "hoy" queda viejo.
    // COMO ARREGLARLO: sacar este atributo y usar "new Date()" dentro de cada metodo que lo necesite
    // (como ya haces en Noticia.esReciente()).
//    const hoy = new Date()

    method prefiere(noticia) = preferencia.leGusta(noticia)
    method publicarNoticia(noticia){
        self.validarEscritura(noticia)
        self.validarLimiteNoPreferidas(noticia)
        noticiasPublicadas.add(noticia)
    }

    method validarEscritura(noticia){
        if(!noticia.estaBienEscrita())
            self.error("La noticia no esta bien escrita")
    }
    method validarLimiteNoPreferidas(noticia){
        if(!self.prefiere(noticia) && self.noPreferidasDeHoy() >= 2)
            self.error("Ya publico 2 noticias que no prefiere en el dia de hoy")
    }
    method noPreferidasDeHoy() = noticiasPublicadas.count({noticia => noticia.fechaPublicacion() == new Date() && !self.prefiere(noticia)})

    // ERROR 5 (grave, punto 4): "la semana pasada" esta resuelto con plusYears(1), que es un ANIO, no una semana.
    // Ademas la cuenta esta al reves: pregunta si (fecha + 1 anio) >= hoy, que casi siempre da true.
    // Tambien esta mal el enfoque: el periodista tiene que mirar SUS noticiasPublicadas, no recibir una noticia.
    // COMO ARREGLARLO (sin parametros, usando declaratividad):
    method publicoEnLaUltimaSemana() = noticiasPublicadas.any({noticia => noticia.fechaPublicacion() >= new Date().minusDays(7)})
    // Esta cuenta SI esta bien (ingreso hace un anio o menos). Solo el nombre es confuso:
    // sugerencia: "ingresoHaceUnAnioOMenos()" o "esNuevo()", sin usar "hoy" como atributo (ver ERROR 4).
    method periodistaNuevo() = fechaIngreso.plusYears(1) >= new Date()

    // ERROR 6 (medio, punto 4): este metodo recibe una noticia, pero "periodista reciente" es una
    // propiedad del periodista, sin parametros.
    // COMO ARREGLARLO: method esReciente() = self.ingresoHaceUnAnioOMenos() && self.publicoEnLaUltimaSemana()
    // Y para "cuales son los periodistas recientes" hace falta algo que conozca a TODOS los periodistas
    // (por ejemplo un object "multimedio" con una lista) y haga: periodistas.filter({p => p.esReciente()})
    method periodistaReciente() = self.publicoEnLaUltimaSemana() && self.periodistaNuevo()
}

class NoticiasCopadas{
    method leGusta(noticia) = noticia.esCopada()
}

class Sensacionalista{
    // ERROR 7 (medio): faltan los acentos del enunciado: "increíble" y "Dibu Martínez".
    // Wollok acepta acentos. Si el test usa el texto del enunciado, estas comparaciones fallan.
    // COMO ARREGLARLO: "increíble" y "Dibu Martínez"
    const palabrasClave = ["espectacular", "increible", "grandioso"]
    const entrevistadoPreferido = "Dibu Martinez"

    method leGusta(noticia) = self.tienePalabraClave(noticia.titulo()) && noticia.aceptaEntrevistado(entrevistadoPreferido)

    // ERROR 8 (medio): contains() distingue mayusculas. "Espectacular gol" NO matchea "espectacular".
    // COMO ARREGLARLO: titulo.toLowerCase().contains(palabra)
    method tienePalabraClave(titulo) = palabrasClave.any({palabra => titulo.toLowerCase().contains(palabra)})
}

class Vago{
    const limitePalabras = 100

    method leGusta(noticia) = noticia.esChivo() || self.desarrolloAcotado(noticia)

    method desarrolloAcotado(noticia) = noticia.desarrollo().words().size() < limitePalabras
}

// ERROR 9 (menor): typo en el nombre, es "De Zer", no "De Zar". Renombrar a joseDeZer
// (y acordate de actualizar donde lo uses).
object joseDeZer {
  const primeraLetra = "T"

  method leGusta(noticia) = noticia.titulo().startsWith(primeraLetra)
}

// Punto 4: conoce a todos los periodistas y delega en cada uno la pregunta "sos reciente?"
object multimedio {
    const periodistas = []

    method agregarPeriodista(periodista) { periodistas.add(periodista) }
    method periodistasRecientes() = periodistas.filter({periodista => periodista.periodistaReciente()})
}
