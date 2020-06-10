Extension { #name : #Symbol }

{ #category : #'*BytePusher-Assembler' }
Symbol >> forAssembler: anAssembler [
	^ [ (anAssembler registerNamed: self) address ]
		on: NotFound
		do: [ BPLabelReference label: self]
]
