function getItem(h)
{
	switch (h)
	{
		case 'phoenix.de': return {strict: false, key: 'user_anonymous_profile', value: '{"config":{"tracking":false,"userprofile":false,"youtube":false,"twitter":false,"facebook":false,"iframe":false,"video":{"useSubtitles":false,"useAudioDescription":false}},"votings":[],"msgflash":[],"history":[]}'};
	}
	
	
	const parts = h.split('.');
	
	if (parts.length > 2)
	{
		parts.shift();
		return getItem(parts.join('.'));
	}
	
	return false;
}


let	h = document.location.hostname.replace(/^w{2,3}\d*\./i, ''),
	item = getItem(h);

if (item) {
	let value = localStorage.getItem(item.key);
	
	if (value == null || (item.strict && value != item.value)) {
		localStorage.setItem(item.key, item.value);
		document.location.reload();
	}
}