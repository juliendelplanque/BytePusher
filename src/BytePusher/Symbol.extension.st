Extension { #name : #Symbol }

{ #category : #'*BytePusher' }
Symbol >> forAssembler: anAssembler [
	^ [ anAssembler registerNamed: self ]
		on: NotFound
		do: [ BPLabelReference label: self]
]

{ #category : #'*BytePusher' }
Symbol >> forAssembly: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ ^ anAssembly labelNamed: self ]
]
