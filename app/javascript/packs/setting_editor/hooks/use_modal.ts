import { useState, useReducer } from 'react';
import { Button } from 'types/button';
import { ModalProps } from 'setting_editor/components/buttons_modal';

export type ModalSetting = {
  toggleModal: any;
  setCallbackOnSubmit: any;
  setCallbackOnClose: any;
  setTitle: any;
  setPrefillButtons: any;
};

type openModalParams = {
  title: string;
  prefill: any;
  callbackOnSubmit: any;
};

export const useModal = () => {
  const [visible, toggleModal] = useReducer((m: boolean) => {
    return !m;
  }, false);
  const [callbackOnSubmit, setCallbackOnSubmit] = useState(undefined as any);
  const [callbackOnClose, setCallbackOnClose] = useState(undefined as any);
  const [title, setTitle] = useState('');
  const [prefill, setPrefillButtons] = useState<Array<Button>>([]);

  const openModal = ({
    title,
    prefill,
    callbackOnSubmit,
  }: openModalParams): void => {
    toggleModal();
    setTitle(title);
    setPrefillButtons(prefill);
    setCallbackOnSubmit(() => callbackOnSubmit);
    setCallbackOnClose(() => toggleModal);
  };
  const modalProps: ModalProps = {
    visible,
    callbackOnSubmit,
    callbackOnClose,
    title,
    prefill,
  };

  return [modalProps, openModal] as const;
};
