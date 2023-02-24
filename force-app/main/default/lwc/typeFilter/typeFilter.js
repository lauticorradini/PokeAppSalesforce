import { LightningElement } from 'lwc';

export default class TypeFilter extends LightningElement {
    selectedType = null;
    opciones = [
        { label: 'Normal', value: 'Normal' },
        { label: 'Fighting', value: 'Fighting' },
        { label: 'Flying', value: 'Flying' },
        { label: 'Poison', value: 'Poison' },
        { label: 'Ground', value: 'Ground' },
        { label: 'Rock', value: 'Rock' },
        { label: 'Bug', value: 'Bug' },
        { label: 'Ghost', value: 'Ghost' },
        { label: 'Steel', value: 'Steel' },
        { label: 'Fire', value: 'Fire' },
        { label: 'Water', value: 'Water' },
        { label: 'Grass', value: 'Grass' },
        { label: 'Electric', value: 'Electric' },
        { label: 'Psychic', value: 'Psychic' },
        { label: 'Ice', value: 'Ice' },
        { label: 'Dragon', value: 'Dragon' },
        { label: 'Dark', value: 'Dark' },
        { label: 'Fairy', value: 'Fairy' },
    ];

    get selected() {
        return this.selectedType.length ? this.selectedType : 'Ninguno';
    }
    
    get max(){
        return 2;
    }

    handleChange(event) {
        this.selectedType = event.detail.value;
        const typeChangeEvent = new CustomEvent("typechange", { 
            detail: this.selectedType 
        });
        this.dispatchEvent(typeChangeEvent);
    }
}