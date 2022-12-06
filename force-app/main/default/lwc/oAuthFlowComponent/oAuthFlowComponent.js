import { LightningElement,wire,api } from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import getAccessToken from '@salesforce/apex/MakeCalloutOAuth.getAccessToken';
import createAccount from '@salesforce/apex/MakeCalloutOAuth.createAccount';

export default class OAuthFlowComponent extends NavigationMixin(LightningElement) {
    authURL = 'https://YOUR_MY_DOMAIN.my.salesforce.com/services/oauth2/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URL&response_type=code'

    currentPageReference = null; 
    urlStateParameters = null;
    showAuth = true
    accessToken = false
    showError = false
    errorMessage
    createdAccount = false
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          console.log(this.urlStateParameters)
          if (this.urlStateParameters.code) {
            this.showAuth = false
          }
       }
    }

    get showAccessToken() {
        return (this.accessToken).substring(0,18)
    }
    handleClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.authURL
            }
        },
        true // Replaces the current page in your browser history with the URL
        );
    }

    handleClickAccess() {
        getAccessToken({ authCode: this.urlStateParameters.code })
        .then(result => {
            console.log(result)
            const obj = JSON.parse(result)
            if(obj.hasOwnProperty('error')) {
                this.showError = obj['error']
                this.errorMessage = obj['error_description']
                return
            }
            this.accessToken = obj['access_token']
            console.log(this.accessToken)
        })
        .catch(error => {
            console.error(error)
        });

    }
    handleAccountCreation() {
        var inputCmp = this.template.querySelector('.inputCmp');
        var value = inputCmp.value;
        console.log('value',value)
        if(value=='' || value==undefined || value==null) {
            inputCmp.reportValidity();
            return
        }

        createAccount({accessToken:this.accessToken,accName:value}).then(result=>{
            console.log(result)
            const obj = JSON.parse(result)
            this.createdAccount = obj['id']
        }).catch(error=>{
            console.error(error)
        })

    }
}




















































/*         let options = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Access-Control-Allow-Origin': '*'
            },
            data : {
                'grant_type':'authorization_code',
                'code':this.urlStateParameters.code,
                'client_id':'3MVG9G9pzCUSkzZuMBAg7ptzi3TDVjaoWN8yqu_4YSqUA8rtTLfR8jBA8IpaebSrQVsVnDoK1ddDiZSclVjBA',
                'client_secret':'5591E86C4589A73E6C48D2E92EB9D8029334D2D803CB46074E626A435A2B5140',
                'redirect_uri':'https://resourceful-shark-uejdrk-dev-ed.my.site.com'
            }
        }
        // Make POST call
        let fetchRes = fetch("https://login.salesforce.com/services/oauth2/token", options);

        fetchRes.then(res=>{
            console.log(res)
        }) */