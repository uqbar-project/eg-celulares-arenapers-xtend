package ar.edu.celulares.home

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.ModeloCelular
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import uqbar.arena.persistence.PersistentHome

@Observable
class HomeCelulares extends PersistentHome<Celular> {

	override def getEntityType() {
		typeof(Celular)
	}

	override def createExample() {
		new Celular
	}

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
		(ApplicationContext.instance.getSingleton(typeof(ModeloCelular)) as HomeModelos).get(modeloDescripcion)
	}

	// ********************************************************
	// ** Altas y bajas
	// ********************************************************
	def createIfNotExists(Celular celular) {
		var celularDB = this.get(celular.numero)
		if (celularDB == null) {
			this.create(celular)
			celularDB = celular
		}
		celularDB
	}
	
	def void createIfNotExists(String pNombre, Integer pNumero, ModeloCelular pModeloCelular, Boolean pRecibeResumenCuenta) {
		var celular = new Celular => [
			nombre = pNombre
			numero = pNumero
			modeloCelular = pModeloCelular
			recibeResumenCuenta = pRecibeResumenCuenta
		]
		this.createIfNotExists(celular)
	}

	def Celular get(Integer numero) {
		allInstances().findFirst [ celular | celular.numero.equals(numero) ] 
	}
	
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

	// ********************************************************
	// ** Búsquedas
	// ********************************************************
	def search(Integer numero) {
		this.search(numero, null)
	}

	/**
	 * Busca los celulares que coincidan con los datos recibidos. Tanto número como nombre pueden ser nulos,
	 * en ese caso no se filtra por ese atributo.
	 *
	 * Soporta búsquedas por substring, por ejemplo el celular (12345, "Juan Gonzalez") será contemplado por
	 * la búsqueda (23, "Gonza")
	 */
	def search(Integer numero, String nombre) {
		allInstances.filter[celular|this.match(numero, celular.numero) && this.match(nombre, celular.nombre)].toList
	}

	def match(Object expectedValue, Object realValue) {
		if (expectedValue == null) {
			return true
		}
		if (realValue == null) {
			return false
		}
		realValue.toString().toLowerCase().contains(expectedValue.toString().toLowerCase())
	}

	/**
	 * Para el proyecto web - se mantiene la busqueda por Identificador
	 */
	override def searchById(int id) {
		allInstances.findFirst[celular|celular.id.equals(id)]
	}

}
