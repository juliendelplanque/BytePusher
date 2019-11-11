Extension { #name : #Symbol }

{ #category : #'*BytePusher-OldAssembler' }
Symbol >> forAssembly: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ ^ anAssembly labelNamed: self ]
]
