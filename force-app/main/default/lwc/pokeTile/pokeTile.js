import { LightningElement, api } from 'lwc';

export default class PokeTile extends LightningElement {
    @api pokemon;
    pokemonClass = [];

    connectedCallback(){
        this.pokemonClass = this.getClassByType(this.pokemon.Tipos__c);
    }

    getClassByType(pokemonType){
        let tipos = pokemonType.split(";");
        let tiposConClase = [];
        tipos.forEach(tipo => {
            switch (tipo) {
                case 'Fire':
                    tiposConClase.push({ name: tipo, class: 'fire-badge' });
                    break;
                case 'Water':
                    tiposConClase.push({ name: tipo, class: 'water-badge' });
                    break;
                case 'Grass':
                    tiposConClase.push({ name: tipo, class: 'grass-badge' });
                    break;
                case 'Poison':
                    tiposConClase.push({ name: tipo, class: 'poison-badge' });
                    break;
                case 'Electric':
                    tiposConClase.push({ name: tipo, class: 'electric-badge' });
                    break;
                case 'Ice':
                    tiposConClase.push({ name: tipo, class: 'ice-badge' });
                    break;
                case 'Fighting':
                    tiposConClase.push({ name: tipo, class: 'fighting-badge' });
                    break;
                case 'Ground':
                    tiposConClase.push({ name: tipo, class: 'ground-badge' });
                    break;
                case 'Flying':
                    tiposConClase.push({ name: tipo, class: 'flying-badge' });
                    break;
                case 'Psychic':
                    tiposConClase.push({ name: tipo, class: 'psychic-badge' });
                    break;
                case 'Bug':
                    tiposConClase.push({ name: tipo, class: 'bug-badge' });
                    break;
                case 'Rock':
                    tiposConClase.push({ name: tipo, class: 'rock-badge' });
                    break;
                case 'Ghost':
                    tiposConClase.push({ name: tipo, class: 'ghost-badge' });
                    break;
                case 'Dragon':
                    tiposConClase.push({ name: tipo, class: 'dragon-badge' });
                    break;
                case 'Dark':
                    tiposConClase.push({ name: tipo, class: 'dark-badge' });
                    break;  
                case 'Steel':
                    tiposConClase.push({ name: tipo, class: 'steel-badge' });
                    break;
                case 'Fairy':
                    tiposConClase.push({ name: tipo, class: 'fairy-badge' });
                    break;  
                default:
                    tiposConClase.push({ name: tipo, class: 'normal-badge' });
            }
        });
        return tiposConClase;
    }
    
    handleImgClick(){
        const selectEvent = new CustomEvent('pokeview', {
            detail: this.pokemon.Id
        });
        this.dispatchEvent(selectEvent);
    }
}