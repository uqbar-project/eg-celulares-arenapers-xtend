package ar.edu.celularesPers.runnable

import ar.edu.celularesPers.domain.Celular
import ar.edu.celularesPers.domain.ModeloCelular
import ar.edu.celularesPers.repos.RepoCelulares
import ar.edu.celularesPers.repos.RepoModelos
import org.uqbar.arena.bootstrap.Bootstrap
import org.uqbar.commons.utils.ApplicationContext

class CelularesBootstrap implements Bootstrap {

	override isPending() {
		// por cómo está definido 
		true
	}

	override run() {
		val repoModelos = ApplicationContext.instance.getSingleton(typeof(ModeloCelular)) as RepoModelos
	
		repoModelos => [
			createIfNotExists("NOKIA ASHA 501", 700f, true)
			createIfNotExists("LG OPTIMUS L5 II", 920f, false)
			createIfNotExists("LG OPTIMUS L3 II", 450f, true)
			createIfNotExists("NOKIA LUMIA 625", 350f, true)
			createIfNotExists("MOTOROLA RAZR V3", 350f, false)
		]

		val repoCelulares = ApplicationContext.instance.getSingleton(typeof(Celular)) as RepoCelulares
		
		repoCelulares => [
			createIfNotExists("Laura Iturbe", 88022202, getModelo("NOKIA LUMIA 625"), false)
			createIfNotExists("Julieta Passerini", 45636453, getModelo("NOKIA ASHA 501"), false)
			createIfNotExists("Debora Fortini", 45610892, getModelo("NOKIA ASHA 501"), true)
			createIfNotExists("Chiara Dodino", 68026976, getModelo("NOKIA ASHA 501"), false)
			createIfNotExists("Melina Dodino", 40989911, getModelo("LG OPTIMUS L3 II"), true)
		]
	}

}
