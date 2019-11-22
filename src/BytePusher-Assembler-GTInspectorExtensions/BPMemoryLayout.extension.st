Extension { #name : #BPMemoryLayout }

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPMemoryLayout >> gtInspectorLayoutIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ (composite fastTable)
		title: 'Layout';
		display: [ self layoutObjects ];
		column: 'Name' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each name ];
		column: 'Type'
			evaluated: [ :each | each typeName ];
		column: 'Start address' 
			evaluated: [:each | each startAddress hex ] width: 80;
		column: 'End address' 
			evaluated: [:each | each endAddress hex ] width: 80;
		beSingle;
		yourself
]
