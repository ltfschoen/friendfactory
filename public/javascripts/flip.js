/*
	Triggers transition between both states of the card: regular and flipped.
	A card is in a regular state when there is an empty transform applied to it, and 
	otherwise in a flipped state, where there is a rotational transformation applied.
	The CSS "card" class is used when the card is in a regular state. The "card flipped" 
	class is used when the card is in a flipped state.
	
	This function is called when users tap on the "card" div element. It checks this div's
	current CSS classname attribute. If the current classname is "card," then change it to "card flipped" and "card,"
	ortherwise.	
*/
function flip (event)
{
	var element = event.currentTarget;
	/* Toggle the setting of the classname attribute */
	element.className = (element.className == 'polaroid') ? 'polaroid flipped' : 'polaroid';
}


