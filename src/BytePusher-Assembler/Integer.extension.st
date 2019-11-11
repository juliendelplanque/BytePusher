Extension { #name : #Integer }

{ #category : #'*BytePusher-Assembler' }
Integer >> asBPAddress [
	^ BPAddress memoryAddress: self
]

{ #category : #'*BytePusher-Assembler' }
Integer >> forAssembler: anAssembler [
	(self between: 0 and: 255)
		ifFalse: [ BPNotAByte signalForValue: self ].
	^ (anAssembler memoryLayout reservedMemoryZoneNamed: #IDENTITY_PAGE) + self
]
