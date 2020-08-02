({
	doInit: function (component, event) {
		var responseValue;
		component.set("v.showTable", true); // If one among "Product Type" or "Home Country" are filled we show the table
		var action = component.get('c.getCustomerDetails');
		action.setParams({
			"caseId" : component.get('v.recordId')
		});

		action.setCallback(this, function(response){
			var state = response.getState();
			if(state == 'SUCCESS') {
				component.set("v.customerDataWrapper", response.getReturnValue());
				responseValue = response.getReturnValue();
				if (responseValue.productType == 'Not Set' && responseValue.homeCountry == 'Not Set') {
					component.set("v.showTable", false); // If both "Product Type" and "Home Country" are empty we don't show the table
				}
			}
		});
		$A.enqueueAction(action);
	}
})