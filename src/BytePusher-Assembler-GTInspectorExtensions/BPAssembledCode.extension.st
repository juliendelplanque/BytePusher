Extension { #name : #BPAssembledCode }

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorInstructionsIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ composite fastTable
		title: 'Instructions';
		display: [ self instructions ];
		wantsAutomaticRefresh: true;
		column: 'Labels' evaluated: [ :instruction | ((self labelsFor: instruction) collect: #label) joinUsing: ', ' ] width: 100;
		column: 'Address' evaluated: [ :instruction | instruction address hex ] width: 75;
		column: 'Source' evaluated: [ :instruction | instruction fromAddress hex ] width: 75;
		column: 'Target' evaluated: [ :instruction | instruction toAddress hex ] width: 75;
		column: 'Jump' evaluated: [ :instruction |instruction jumpAddress hex ] width: 75;
		column: 'Tag' evaluated: [ :instruction | GTObjectPrinter asTruncatedTextFrom: instruction tag ]
]

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorLayoutIn: composite [
	<gtInspectorPresentationOrder: 1> 
	^ self memoryLayout gtInspectorLayoutIn: composite
]
