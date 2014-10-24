package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import org.uqbar.arena.windows.WindowOwner

class CrearCelularWindow extends EditarCelularWindow {
	
	new(WindowOwner owner) {
		super(owner, new Celular)
	}

	override executeTask() {
		repoCelulares.create(modelObject)
		super.executeTask()
	}

}