package ar.edu.celulares.runnable

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.ModeloCelular
import ar.edu.celulares.home.HomeCelulares
import ar.edu.celulares.home.HomeModelos
import ar.edu.celulares.ui.BuscarCelularesWindow
import org.uqbar.arena.Application
import org.uqbar.commons.utils.ApplicationContext
import uqbar.arena.persistence.Configuration

class CelularApplication extends Application {
	
	static def void main(String[] args) { 
		new CelularApplication().start()
	}

	override createMainWindow() {
		Configuration.configure()
		ApplicationContext.instance.configureSingleton(typeof(ModeloCelular), new HomeModelos)
		ApplicationContext.instance.configureSingleton(typeof(Celular), new HomeCelulares)
		return new BuscarCelularesWindow(this)
	}
	
}
