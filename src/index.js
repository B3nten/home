class LoadingIndicator extends HTMLElement
{
	static
	{
		if(typeof document !== 'undefined' && 'customElements' in document)
		{
			if(!customElements.get("loading-indicator"))
				customElements.define("loading-indicator", LoadingIndicator);
		}
	}

	BeginLoad()
	{

	}

	EndLoad()
	{

	}

	connectedCallback()
	{

	}

	disconnectedCallback()
	{

	}
}


class Blitz
{

}
