import { LightningElement, wire } from 'lwc';
import getGenerations from '@salesforce/apex/PokemonController.getGenerations';

export default class GenerationFilter extends LightningElement {
    opciones =[{label: 'Todas', value: 0}];
    selectedGeneration = null;
    records =[];
	countRecords;
        
    @wire(getGenerations)
    wiredRecords({ data, error}){
        if (data) {
            this.opciones = [{label: 'Todas', value: 0}, ...data.map(gen => { return { label: gen, value: gen } })];
        } else if (error) { 
            console.log(error);
        }
    }

    handleChange(event){
        this.selectedGeneration = event.detail.value;
        const generationChangeEvent = new CustomEvent("generationchange", { 
            detail: this.selectedGeneration 
        });
        this.dispatchEvent(generationChangeEvent);
    }
}