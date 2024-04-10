import { useQuery } from '@apollo/client';
import { Trans } from '@lingui/macro';
import clsx from 'clsx';
import React from 'react';
import { Col, Row } from 'react-bootstrap';
import { useAppSelector } from '../../hooks';
import { useShortAddress } from '../../utils/addressAndENSDisplayUtils';
import { buildEtherscanAddressLink } from '../../utils/etherscan';
import { useNoundersDAO } from '../../wrappers/nounToken';
import { nounQuery } from '../../wrappers/subgraph';
import ShortAddress from '../ShortAddress';
import Tooltip from '../Tooltip';
import classes from './Holder.module.css';

interface HolderProps {
  nounId: number;
  isNounders?: boolean;
}

const Holder: React.FC<HolderProps> = props => {
  const { nounId, isNounders } = props;

  const isCool = useAppSelector(state => state.application.isCoolBackground);
  const nounderNounContent = useShortAddress(useNoundersDAO() ?? '');

  const { loading, error, data } = useQuery(nounQuery(nounId.toString()));

  if (loading) {
    return <></>;
  } else if (error) {
    return (
      <div>
        <Trans>Failed to fetch Niji Noun info</Trans>
      </div>
    );
  }

  const holder = data && data.noun.owner.id;

  const nonNounderNounContent = (
    <a
      href={buildEtherscanAddressLink(holder)}
      target={'_blank'}
      rel="noreferrer"
      className={classes.link}
    >
      <Tooltip
        tip="View on Etherscan"
        tooltipContent={(tip: string) => {
          return <Trans>View on Etherscan</Trans>;
        }}
        id="holder-etherscan-tooltip"
      >
        <ShortAddress size={40} address={holder} avatar={true} />
      </Tooltip>
    </a>
  );

  return (
    <>
      <Row className={clsx(classes.wrapper, classes.section)}>
        <Col xs={1} lg={12} className={classes.leftCol}>
          <h4
            style={{
              color: isCool ? 'var(--brand-cool-light-text)' : 'var(--brand-warm-light-text)',
            }}
            className={classes.holderCopy}
          >
            <Trans>Held by</Trans>
          </h4>
        </Col>
        <Col xs="auto" lg={12}>
          <h2
            className={classes.holderContent}
            style={{
              color: isCool ? 'var(--brand-cool-dark-text)' : 'var(--brand-warm-dark-text)',
            }}
          >
            {isNounders ? nounderNounContent : nonNounderNounContent}
          </h2>
        </Col>
      </Row>
    </>
  );
};

export default Holder;
