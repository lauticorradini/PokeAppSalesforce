import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, track, wire } from 'lwc';
import searchPokemon from '@salesforce/apex/PokemonController.searchPokemon';
import getAllPokemons from '@salesforce/apex/PokemonController.getAllPokemons';
import getRecordsByGeneration from '@salesforce/apex/PokemonController.getRecordsByGeneration';
import getTypes from '@salesforce/apex/PokemonController.getTypes';


export default class PokeList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	searchResults;
	selectedGeneration = null;
	selectedType = null;
	filteredPokemons;
	@track countRecords;
	@wire(searchPokemon, {searchTerm: '$searchTerm'}) pokemons;
	
	@wire(getAllPokemons)
	wiredAllPokemons({ data,error }) {
		if (data) {
			this.filteredPokemons = data;
			console.log('wired de pokemons');
			console.log(this.filteredPokemons);
            this.countRecords = Object.keys(this.filteredPokemons).length;
        } else if (error) {
            console.error(error);
        }
	}

    @wire(getRecordsByGeneration, { generation: '$selectedGeneration' })
    wiredRecordsByGeneration({ data, error }) {
        if (data) {
			try{
				this.filteredPokemons = data;
				console.log('wired de generacion');
				console.log(this.filteredPokemons);
				this.countRecords = Object.keys(this.filteredPokemons).length;
			}catch(e){
				console.error(e);
			}
        } else if (error) {
            console.error(error);
        }
    }

	@wire(getTypes, {type: '$selectedType'})
	wiredTypes({ data, error }){
		if (Array.isArray(this.selectedType)) {
			const type = this.selectedType.join(';');
			this.selectedType = type;
		}
		if (data) { 
			this.filteredPokemons = data;
			console.log('wired de types');
			console.log(this.filteredPokemons);
			this.countRecords = Object.keys(this.filteredPokemons).length;
		} else if (error) {
			console.error(error);
		}
	}
	
	handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		this.delayTimeout = setTimeout(() => {			
			this.searchTerm = searchTerm;
			this.filteredPokemons = this.pokemons.data;
			this.countRecords = Object.keys(this.filteredPokemons).length;
		}, 300);
	}

	get hasResults() {
		return (this.filteredPokemons.length > 0);
	}

	handleFilter(event) {
		const choice = event.detail;
		if(choice === 0){
			this.selectedGeneration = 0;
		}else{
			this.selectedGeneration = choice;
		}
	}

	handleType(event){
		const type = event.detail;
		this.selectedType = type;
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
}
