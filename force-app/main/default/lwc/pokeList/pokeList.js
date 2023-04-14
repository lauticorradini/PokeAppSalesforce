import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, wire } from 'lwc';
import getFilteredPokemons from '@salesforce/apex/PokemonController.getFilteredPokemons';
export default class PokeList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	selectedGeneration = 0;
	selectedType = '';
	countRecords = 0;
	error;
	filteredPokemons;
	visiblePokemons;
	
	@wire(getFilteredPokemons,{
		searchTerm :'$searchTerm', 
		generation: '$selectedGeneration', 
		types : '$selectedType'
	})
	wiredPokemonsLoad({data, error}){
		if(data){
			if (this.filteredPokemons != data){
				this.filteredPokemons = data; 
			}
			if (this.filteredPokemons){
				this.countRecords = Object.keys(this.filteredPokemons).length;
			}
		} else if(error){
			this.error = error;
		}
	}

	handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		this.delayTimeout = setTimeout(() => {			
			this.searchTerm = searchTerm;
		}, 300);
	}

	get hasResults() {
		return (this.filteredPokemons.length > 0);
	}

	handleFilter(event) {
		this.selectedGeneration = event.detail;
	}

	handleType(event){
		this.selectedType = event.detail;
		if (Array.isArray(this.selectedType)) {
			const type = this.selectedType.join(';');
			this.selectedType = type;
		}
	}
	
	handlePokeView(event){
		const pokeId = event.detail;
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: pokeId,
				objectApiName: 'Pokemon__c',
				actionName: 'view',
			},
		});
	}

	//PAGINATION
	updateHandler(event){
		console.log("update handler:");
		this.visiblePokemons = [...event.detail.records]
		console.log(event.detail.records)
	}
}
