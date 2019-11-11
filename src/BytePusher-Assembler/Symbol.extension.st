Extension { #name : #Symbol }

{ #category : #'*BytePusher-Assembler' }
Symbol >> forAssembler: anAssembler [
	^ [ anAssembler registerNamed: self ]
		on: NotFound
		do: [ BPLabelReference label: self]
]
