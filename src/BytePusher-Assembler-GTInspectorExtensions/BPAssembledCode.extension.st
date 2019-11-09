Extension { #name : #BPAssembledCode }

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ composite fastTable
		title: 'Instructions';
		display: [ self instructions ];
		wantsAutomaticRefresh: true;
		column: 'Address' evaluated: [ :instruction | instruction address hex ] width: 75;
		column: 'Source' evaluated: [ :instruction | instruction fromAddress hex ] width: 75;
		column: 'Target' evaluated: [ :instruction | instruction toAddress hex ] width: 75;
		column: 'Jump' evaluated: [ :instruction |instruction jumpAddress hex ] width: 75;
		column: 'Tag' evaluated: [ :instruction | GTObjectPrinter asTruncatedTextFrom: instruction tag ]
]
