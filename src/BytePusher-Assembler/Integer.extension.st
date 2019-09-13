Extension { #name : #Integer }

{ #category : #'*BytePusher-Assembler' }
Integer >> forAssembler: anAssembler [
	| data |
	data := BPData byte: self.
	anAssembler addInstruction: data.
	^ data asReference
]
