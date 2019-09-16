Extension { #name : #BPAssembledCode }

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ composite fastTable
		title: 'Instructions';
		display: [ self instructions ];
		wantsAutomaticRefresh: true;
		column: 'Address' evaluated: [ :instruction | instruction address hex ] width: 75;
		column: 'Instruction' evaluated: [ :instruction | GTObjectPrinter asTruncatedTextFrom: instruction ] width: 225;
		column: 'Tag' evaluated: [ :instruction | GTObjectPrinter asTruncatedTextFrom: instruction tag ]
]
