package ar.edu.celulares.repos

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.ModeloCelular
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import uqbar.arena.persistence.PersistentHome

@Observable
class RepoCelulares extends PersistentHome<Celular> {

	override def getEntityType() {
		typeof(Celular)
	}

	override def createExample() {
		new Celular
	}

	// ********************************************************
	// ** Inicialización fixture
	// ********************************************************
	new() {
		this.init
	}

	def void init() {
		this.createIfNotExists("Laura Iturbe", 88022202, getModelo("NOKIA LUMIA 625"), false)
		this.createIfNotExists("Julieta Passerini", 45636453, getModelo("NOKIA ASHA 501"), false)
		this.createIfNotExists("Debora Fortini", 45610892, getModelo("NOKIA ASHA 501"), true)
		this.createIfNotExists("Chiara Dodino", 68026976, getModelo("NOKIA ASHA 501"), false)
		this.createIfNotExists("Melina Dodino", 40989911, getModelo("LG OPTIMUS L3 II"), true)
	}

	def getModelo(String modeloDescripcion) {
		(ApplicationContext.instance.getSingleton(typeof(ModeloCelular)) as RepoModelos).get(modeloDescripcion)
	}

	// ********************************************************
	// ** Altas y bajas
	// ********************************************************
	override create(Celular celular) {
		celular.validar
		validarClientesDuplicados(celular)
		super.create(celular)
	}

	def void validarClientesDuplicados(Celular celular) {
		val numero = celular.numero
		if (!this.search(numero).isEmpty) {
			throw new UserException("Ya existe un celular con el número: " + numero)
		}
	}

	def createIfNotExists(Celular celular) {
		var celularDB = this.get(celular.numero)
		if (celularDB == null) {
			this.create(celular)
			celularDB = celular
		}
		celularDB
	}

	def void createIfNotExists(String pNombre, Integer pNumero, ModeloCelular pModeloCelular,
		Boolean pRecibeResumenCuenta) {
		var celular = new Celular => [
			nombre = pNombre
			numero = pNumero
			modeloCelular = pModeloCelular
			recibeResumenCuenta = pRecibeResumenCuenta
		]
		this.createIfNotExists(celular)
	}

	// ********************************************************
	// ** Búsquedas
	// ********************************************************
	/**
	 * Devuelve un celular en base al número (que no puede repetirse)
	 */
	def Celular get(Integer unNumero) {
		val celulares = this.search(unNumero)
		if (celulares.isEmpty) {
			null
		} else {
			celulares.get(0)
		}
	}

	/**
	 * Hace la búsqueda de un celular únicamente por número
	 */
	def search(Integer numero) {
		this.search(numero, null)
	}

	/**
	 * Busca los celulares que coincidan con los datos recibidos. Tanto número como nombre pueden ser nulos,
	 * en ese caso no se filtra por ese atributo.
	 *
	 * Para soportar búsquedas por substring hay que descomentar todo el código de abajo, el problema es que trae 
	 * a memoria todo el grafo de celulares (con una cantidad enorme de celulares puede traer problemas de performance)
	 * En ese caso el celular (12345, "Juan Gonzalez") será contemplado por la búsqueda (23, "Gonza")
	 * 
	 * Actualmente la búsqueda se hace by example pero requiere que sea exactamente ese número o ese nombre
	 * 
	 */
	def search(Integer unNumero, String unNombre) {

		//allInstances.filter[celular|this.match(numero, celular.numero) && this.match(nombre, celular.nombre)].toList
		searchByExample(
			new Celular => [
				numero = unNumero
				nombre = unNombre
			])
	}

//	def match(Object expectedValue, Object realValue) {
//		if (expectedValue == null) {
//			return true
//		}
//		if (realValue == null) {
//			return false
//		}
//		realValue.toString().toLowerCase().contains(expectedValue.toString().toLowerCase())
//	}
}
