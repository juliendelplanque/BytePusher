Extension { #name : #Integer }

{ #category : #'*BytePusher-Assembler' }
Integer >> forAssembler: anAssembler [
	"| data |
	data := BPData byte: self.
	^ data asReference"
	self assert: (self between: 0 and: 255).
	^ (anAssembler memoryLayout reservedMemoryZoneNamed: #IDENTITY_PAGE) + self
]
