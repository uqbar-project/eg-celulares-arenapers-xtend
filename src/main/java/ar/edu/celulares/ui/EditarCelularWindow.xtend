package ar.edu.celulares.ui

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.ModeloCelular
import org.uqbar.arena.bindings.ObservableProperty
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.utils.ApplicationContext
import ar.edu.celulares.repos.RepoCelulares
import ar.edu.celulares.repos.RepoModelos

class EditarCelularWindow extends Dialog<Celular> {

	Celular original
	
	new(WindowOwner owner, Celular model) {
		super(owner, model)
		if (model.isNew) {
			title = "Nuevo celular"
		} else {
			title = "Editar datos del celular"
		}
		original = model.clone() as Celular
	}

	override protected createFormPanel(Panel mainPanel) {
		val form = new Panel(mainPanel)
		form.layout = new ColumnLayout(2)
		new Label(form).text = "Número"
		new TextBox(form) => [
			bindValueToProperty("numero")
			width = 150
			//.withFilter [ event | StringUtils.isNumeric(event.potentialTextResult) ]
		]
			
		new Label(form).text = "Nombre del cliente"
		new TextBox(form) => [
		    bindValueToProperty("nombre")
    		width = 250
		]
		new Label(form).text = "Modelo del aparato"
		new Selector<ModeloCelular>(form) => [
			allowNull = false
			bindValueToProperty("modeloCelular")
			bindItems(new ObservableProperty(repoModelos, "modelos")) => [
				it.adapter = new PropertyAdapter(typeof(ModeloCelular), "descripcionEntera")
			]
		]
		new Label(form).text = "Recibe resumen cuenta en domicilio"
		new CheckBox(form) => [
			bindEnabledToProperty("habilitaResumenCuenta")
			bindValueToProperty("recibeResumenCuenta")
		]
	}

	override protected void addActions(Panel actions) {
		new Button(actions)
			.setCaption("Aceptar")
			.onClick [|this.accept]
			.setAsDefault.disableOnError

		new Button(actions) //
			.setCaption("Cancelar")
			.onClick [|
				if (!original.isNew) {
					original.copiarA(this.modelObject)
				}
				this.cancel
			]
	}

	def getRepoCelulares() {
		ApplicationContext.instance.getSingleton(typeof(Celular)) as RepoCelulares
	}

	def getRepoModelos() {
		ApplicationContext.instance.getSingleton(typeof(ModeloCelular)) as RepoModelos
	}

}
