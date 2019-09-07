Class {
	#name : #BPAddBankBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Core'
}

{ #category : #writing }
BPAddBankBuilder >> endAddress [
	^ 16rE10000 - 1
]

{ #category : #writing }
BPAddBankBuilder >> startAddress [
	^ 16rE00000
]

{ #category : #writing }
BPAddBankBuilder >> writeBankOn: aByteArray [
	self startAddress to: self endAddress do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (x + y) % 16rFF	 ]
]
