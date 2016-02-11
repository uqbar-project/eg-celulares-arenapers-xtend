package ar.edu.celularesPers.repos

import ar.edu.celularesPers.domain.Celular
import ar.edu.celularesPers.domain.ModeloCelular
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import uqbar.arena.persistence.PersistentRepo

@Observable
class RepoCelulares extends PersistentRepo<Celular> {

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

	def void createIfNotExists(String pNombre, Integer pNumero, ModeloCelular pModeloCelular,Boolean pRecibeResumenCuenta) {
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
	 * Para que funcione correctamente el search by example hay que tener cuidado 
	 * ya que se incluyen en la búsqueda cualquiera de los valores de un objeto example que no sean nulos, esto implica
	 * 1) ojo con los tipos primitivos boolean, int, float, etc.
	 * 2) pero además ojo con los valores inicializados por default, tanto en el constructor como en la definición de la clase
	 * ej: Boolean recibeResumenCuenta = false implica que siempre va a buscar a los clientes que no reciban resumen de cuenta
	 *
	 * Para soportar búsquedas por substring hay que descomentar todo el código de abajo, el problema es que trae 
	 * a memoria todo el grafo de celulares (con una cantidad enorme de celulares puede traer problemas de performance)
	 * En ese caso el celular (12345, "Juan Gonzalez") será contemplado por la búsqueda (23, "Gonza")
	 * 
	 * 
	 */
	def search(Integer unNumero, String unNombre) {
//		allInstances.filter[celular|this.match(unNumero, celular.numero) && this.match(unNombre, celular.nombre)].toList
		searchByExample(
			new Celular => [
				if (unNumero != null && unNumero > 0) {
					numero = unNumero
				}
				if (nombre != null && !nombre.equals("")) {
					nombre = unNombre
				}
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
