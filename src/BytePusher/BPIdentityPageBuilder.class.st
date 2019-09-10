Class {
	#name : #BPIdentityPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPIdentityPageBuilder class >> endAddress [
	^ 16rE50000 - 1
]

{ #category : #accessing }
BPIdentityPageBuilder class >> startAddress [
	^ 16rE40000
]

{ #category : #writing }
BPIdentityPageBuilder >> writeBankOn: aByteArray [
	self startAddress to: self endAddress do: [ :address | 
		|x|
		x := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: x ]
]
