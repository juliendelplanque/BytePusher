Extension { #name : #ByteArray }

{ #category : #'*BytePusher-Assembler' }
ByteArray >> bytesRequired [
	^ self size
]

{ #category : #'*BytePusher-Assembler' }
ByteArray >> forAssembler: anAssembler [
	^ self
]
