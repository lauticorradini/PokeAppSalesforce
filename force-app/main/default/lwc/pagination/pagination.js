import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage = 1;
    filteredPokemons;
    @api recordSize = 20;
    totalPage = 0;

    get records(){
        return this.visibleRecords;
    }
    @api 
    set records(data){
        if(data){
            this.filteredPokemons = data;
            this.recordSize = Number(this.recordSize);
            this.totalPage = Math.ceil(data.length / this.recordSize);
            this.updateRecords();
        }
    }

    get disablePrevious(){ 
        return this.currentPage <= 1
    }

    get disableNext(){ 
        return this.currentPage >= this.totalPage
    }
    
    previousHandler(){
		if(this.currentPage > 1){
			this.currentPage = this.currentPage - 1;
			this.updateRecords();
		}
    }

    nextHandler(){
		if(this.currentPage < this.totalPage){
			this.currentPage = this.currentPage + 1;
			this.updateRecords();
		}
    }

    lastPageHandler(){
        if(this.currentPage !== this.totalPage){
            this.currentPage = this.totalPage;
            this.updateRecords();
        }
    }

    firstPageHandler(){
        if(this.currentPage !== 1){
            this.currentPage = 1;
            this.updateRecords();
        }
    }

    updateRecords(){
        const start = (this.currentPage - 1) * this.recordSize;
		const end =  this.recordSize * this.currentPage;
		this.visiblePokemons = this.filteredPokemons.slice(start, end);
        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                records:this.visiblePokemons
            }
        }))
    }
}