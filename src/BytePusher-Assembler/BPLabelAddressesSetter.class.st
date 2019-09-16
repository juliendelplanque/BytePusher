Class {
	#name : #BPLabelAddressesSetter,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'assembler'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPAssembler: aBPAssembler [
	assembler := aBPAssembler.
	aBPAssembler instructions do: [ :instructionToResolve |
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPInstructionToResolve: aBPInstructionToResolve [
	^ aBPInstructionToResolve
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPLabel: aBPLabel [
	| start |
	start := assembler instructions indexOf: aBPLabel.
	
	assembler instructions from: start to: assembler instructions size do: [ :inst |
		inst class = BPInstructionToResolve
			ifTrue: [ aBPLabel address: inst address. ^ aBPLabel ] ].
		
	self error: 'Should not reach this point.'
]
