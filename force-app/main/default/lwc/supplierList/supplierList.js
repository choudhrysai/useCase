import { LightningElement, wire, api, track } from 'lwc';
import getSupplier from '@salesforce/apex/SupplierListController.getSuppliers';

const pageRecordCount = 10;
export default class SupplierList extends LightningElement {
    @api recordId; //Account record id
    @track suppliersMasterList; //Master list for suppliers used in pagination
    @track suppliersCurrentList = []; // The list displayed on the screen

    @track totalSuppliers = 0; // Total number of suppliers
    @track error; //To capture and display error
    @track isLoaded = false; // To display the spinner during load time
    @track pageNo = 0;
    @track pageDetails = ""; // To display the start and end location of the current displyed list
    //To enable and disable the Previous and next button
    @track disableNext = false;
    @track disablePrevious = true;
    //Get the details of the supplier list related to the accounts city
    @wire(getSupplier, { accountId: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            this.isLoaded = true;
            //var unsortedList = JSON.parse(JSON.stringify(data));
            //Sorting the list alphbetically based on the supplier name
            this.suppliersMasterList = data.slice().sort(function (a, b) {
                if (a.supplier.Id > b.supplier.Id) {
                    return 1;
                }
                if (b.supplier.Id > a.supplier.Id) {
                    return -1;
                }
                return 0;
            });
            this.totalSuppliers = data.length;
            this.error = undefined;
            this.updateDisplayList();
        } else if (error) {
            console.error(error);
            this.error = "Something went wrong, Please try again";
            this.suppliersMasterList = undefined;
        }
    }
    //Mathods that added the list of suppliers needs to be displayed for specific page number
    updateDisplayList() {
        if (this.totalSuppliers < 1) {
            this.error = "No Suppliers available for this Account City";
            this.disableNext = true;
        }
        else {
            var arrayStart = this.pageNo * pageRecordCount;
            var arrayEnd = arrayStart + 10;
            if (this.totalSuppliers < arrayEnd) {
                this.disableNext = true;
                arrayEnd = this.totalSuppliers;
            }
            this.pageDetails = (arrayStart + 1) + ' - ' + arrayEnd;
            var masterList = JSON.parse(JSON.stringify(this.suppliersMasterList));
            if (this.totalSuppliers > 1) {
                this.suppliersCurrentList = masterList.slice(arrayStart, arrayEnd);
            }
            else {
                this.suppliersCurrentList = masterList;
            }
        }
    }
    //Handles the onclick event of the previous button to naviagte between pages 
    previousPage() {
        this.disableNext = false;
        this.pageNo = this.pageNo - 1;
        if (this.pageNo == 0) {
            this.disablePrevious = true;
        }
        this.updateDisplayList();
    }
    //Handles the onclick event of the next button to naviagte between pages 
    nextPage() {
        this.suppliersCurrentList = [];
        for (let i = 0; i < this.suppliersCurrentList.length; i++) {
            delete this.suppliersCurrentList[i];
        }
        this.disablePrevious = false;
        this.pageNo = this.pageNo + 1;
        this.updateDisplayList();
    }
    //Handles the Keyup event of the search box. Returns the first 10 nmatching results.
    searchSupplier(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value.toLowerCase();
        if (searchKey) {
            this.delayTimeout = setTimeout(() => {
                var filetredList = this.suppliersMasterList.filter(element => element.supplier.Name.toLowerCase().includes(searchKey));
                this.suppliersCurrentList = filetredList.slice(0, 10);

            }, 300);
        }
        else {
            this.updateDisplayList();
        }
    }
}