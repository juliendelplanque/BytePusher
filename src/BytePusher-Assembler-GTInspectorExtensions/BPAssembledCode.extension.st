Extension { #name : #BPAssembledCode }

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorInstructionsGroupedByAssemblerInstructionIn: composite [
	<gtInspectorPresentationOrder: 1> 
	^ composite fastTree"Table"
		title: 'Instructions (grouped)';
		display: [ (self instructions groupedBy: #assemblerInstruction) associations ];
		wantsAutomaticRefresh: true;
		children: [ :x | x class = Association ifTrue: [ x value ] ifFalse: [ #() ] ];
		yourself
]

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorInstructionsIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ composite fastTable
		title: 'Instructions';
		display: [ self instructions ];
		wantsAutomaticRefresh: true;
		column: 'Labels' evaluated: [ :instruction | ((self labelsFor: instruction) collect: #label) joinUsing: ', ' ] width: 100;
		column: 'Address' evaluated: [ :instruction | instruction address hex ] width: 75;
		column: 'Source' evaluated: [ :instruction | instruction class = BPInstruction
				ifTrue: [ instruction fromAddress hex ]
				ifFalse: [ instruction data hex ] ] width: 75;
		column: 'Target' evaluated: [ :instruction | 
			instruction class = BPInstruction
				ifTrue: [ instruction toAddress hex ]
				ifFalse: [ '' ] ] width: 75;
		column: 'Jump' evaluated: [ :instruction |
			instruction class = BPInstruction
				ifTrue: [ instruction jumpAddress hex ]
				ifFalse: [ '' ] ] width: 75;
		column: 'Tag' evaluated: [ :instruction | GTObjectPrinter asTruncatedTextFrom: instruction tag ]
]

{ #category : #'*BytePusher-Assembler-GTInspectorExtensions' }
BPAssembledCode >> gtInspectorLayoutIn: composite [
	<gtInspectorPresentationOrder: 2> 
	^ self memoryLayout gtInspectorLayoutIn: composite
]
